{-# LANGUAGE TemplateHaskell #-}

module Tests.TemplParser(testGroup) where

import Test.Framework.TH
import Test.Framework.Providers.HUnit
import Test.HUnit
import Dom.TemplParser
import Data.Either

{-# ANN module "HLint: ignore Use camelCase" #-}

checkPH :: [InchoateTempl] -> String -> IO ()
checkPH t s = [t] @=? rights [parseHierarchy s]

checkPTH :: TemplDesc -> String -> IO ()
checkPTH t s = [t] @=? rights [parseTemplHtml s]


case_blank = checkPH [] ""
case_raw1 = checkPH [Raw "asdf"] "asdf"
case_eval1 = checkPH [Eval "span" "asdf"] "<%=asdf%>"
case_eval2 = checkPH [Eval "span" "asdf", Eval "a" "blah"] "<%=asdf%><%a=blah%>"
case_raw_eval = checkPH [Raw "blah", Eval "span" "asdf"] "blah<%=asdf%>"
case_eval_raw = checkPH [Eval "div" "asdf", Raw "blah"] "<%div=asdf%>blah"

case_simple_name = checkPTH (TemplDesc (TemplHead "Asdf" "blah") [Raw "asdf"]) "<? Templ Asdf blah ?>asdf"




testGroup = $(testGroupGenerator)
