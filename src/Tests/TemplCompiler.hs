{-# LANGUAGE TemplateHaskell #-}

module Tests.TemplCompiler(testGroup) where

import Data.Either(rights)
import Test.Framework.TH
import Test.Framework.Providers.HUnit
import Test.HUnit

import Dom.TemplCompiler

{-# ANN module "HLint: ignore Use camelCase" #-}

checkC :: String -> String -> IO ()
checkC o t = [o] @=? rights [compile t]

case_blank = checkC "(CompositeTempl [])" ""
case_raw = checkC "(CompositeTempl [(RawTempl \"asdf\")])" "asdf"
case_raw_escaped = checkC "(CompositeTempl [(RawTempl \"as\\\"df\")])" "as\"df"
case_eval = checkC "(CompositeTempl [(EvalTempl (TemplNode \"span\" Nothing) (\root -> (root)))])" "<%=root%>"
case_re = checkC "(CompositeTempl [(RawTempl \"asdf\"),(EvalTempl (TemplNode \"span\" Nothing) (\root -> (root)))])" "asdf<%=root%>"




testGroup = $(testGroupGenerator)
