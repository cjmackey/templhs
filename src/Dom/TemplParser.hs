module Dom.TemplParser where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Error -- (newErrorMessage, Message)
import Text.Parsec.Pos (initialPos)
import Text.Regex.Posix ((=~))

import Dom.TemplTypes

type Var = String

data TemplDesc = TemplDesc TemplHead [InchoateTempl]
                 deriving (Eq, Show)

data TemplHead = TemplHead String Var
                 deriving (Eq, Show)

data InchoateTempl = Raw String
                   | Eval TagName String
                   deriving (Eq, Show)


simplifyTempls :: [InchoateTempl] -> [InchoateTempl]
simplifyTempls [] = []
simplifyTempls (a:b:xs) =
  case (a,b) of
    (Raw s1, Raw s2) -> simplifyTempls (Raw (s1 ++ s2) : xs)
    _ -> a : simplifyTempls (b:xs)
simplifyTempls x = x

parseTemplHtml :: String -> Either ParseError TemplDesc
parseTemplHtml s = case (parseHierarchy (bef ++ aft)) of
  Left e -> Left e
  Right h -> if length wd <= 3 
             then Left (newErrorMessage (Message "Need templ header!") (initialPos ""))
             else Right (TemplDesc (TemplHead templname templvar) h)
  where (bef, during, aft) = s =~ "<\\?\\s+[Tt]empl\\s+([A-z\\.]+)\\s+([A-z]+)\\s+\\?>"
        wd = words during
        templname = wd !! 2
        templvar = wd !! 3

parseHierarchy :: String -> Either ParseError [InchoateTempl]
parseHierarchy = parse hierarchyParser ""


hierarchyParser :: Parser [InchoateTempl]
hierarchyParser = do
  templs0 <- many (try evalTag <|> rawChar)
  let templs1 = simplifyTempls templs0
  return templs1



evalTag :: Parser InchoateTempl
evalTag = do
  _ <- string "<%"
  ntag <- many $ noneOf "=" 
  let tag = case words ntag of
        [] -> "span"
        (x:_) -> x
  _ <- string "="
  fun <- rest ""
  return $ Eval tag fun
    where rest s = do
            x <- try (string "%>" >> return "") <|> (noneOf "" >>= (\x -> rest [x]))
            return (s ++ x)

rawChar :: Parser InchoateTempl
rawChar = do
  c <- noneOf "\0" 
  return $ Raw [c]






