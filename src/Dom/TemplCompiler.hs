module Dom.TemplCompiler where

import Text.ParserCombinators.Parsec(ParseError)
import Data.List(intercalate)

import Dom.TemplParser


compile :: String -> Either ParseError String
compile input = case parseHierarchy input of  
  Left e -> Left e
  Right h -> Right ("(CompositeTempl [" ++ intercalate "," (map t2s h) ++ "])")

{-
escape :: String -> String
escape [] = []
escape (x:xs) = (case x of
                    '\\' -> "\\"
                    '"' -> "\\\""
                    _ -> (x:[])) ++ escape xs
-}
t2s :: InchoateTempl -> String
t2s (Raw s) = "(RawTempl " ++ show s ++ ")"
t2s (Eval n s) = "(EvalTempl (TemplNode " ++ show n ++ " Nothing) (\\root -> (" ++ s ++ ")))"


