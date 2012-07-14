{-# LANGUAGE TemplateHaskell #-}

module Tests.Templ(testGroup) where

import Test.Framework.TH
import Test.Framework.Providers.HUnit
import Test.HUnit

import Dom.TemplFunctions
import Dom.TemplTypes

{-# ANN module "HLint: ignore Use camelCase" #-}





case_composite = "<span id=\"id_0\">asdf</span>asdf" @=? toStr (CompositeTempl [(EvalTempl (TemplNode "span" Nothing) (\a -> a) Nothing), (RawTempl "asdf")]) "asdf" "id"
case_eval = "<span id=\"id\">asdf</span>" @=? toStr (EvalTempl (TemplNode "span" Nothing) (\a -> a) Nothing) "asdf" "id"
case_raw = "asdf" @=? toStr (RawTempl "asdf") "" "id"



testGroup = $(testGroupGenerator)
