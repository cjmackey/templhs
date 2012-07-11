{-# LANGUAGE TemplateHaskell #-}

module Main where

import Test.Framework (defaultMain)
import Test.Framework.TH

import Tests.TemplParser
import Tests.TemplCompiler

{-# ANN module "HLint: ignore Use camelCase" #-}

main :: IO ()
main = defaultMain [ $(testGroupGenerator)
                   , Tests.TemplParser.testGroup
                   , Tests.TemplCompiler.testGroup
                   ]
