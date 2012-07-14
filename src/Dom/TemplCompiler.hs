module Dom.TemplCompiler where

import Text.ParserCombinators.Parsec(ParseError)
import Data.List(intercalate)

import Dom.TemplParser


compile :: String -> Either ParseError String
compile input = case parseTemplHtml input of  
  Left e -> Left e
  Right (TemplDesc (TemplHead name v) h) -> 
    Right ("module " ++ name ++ " where\nimport Dom.Templ\ntempl = (CompositeTempl [" ++ intercalate "," (map (t2s v) h) ++ "])")

t2s :: Var -> InchoateTempl -> String
t2s _ (Raw s) = "(RawTempl " ++ show s ++ ")"
t2s v (Eval n s) = "(EvalTempl (TemplNode " ++ show n ++ " Nothing) (\\" ++ v ++ " -> (" ++ s ++ ")))"


