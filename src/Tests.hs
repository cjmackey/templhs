{-# LANGUAGE TemplateHaskell #-}

module Main where

import Test.Framework (defaultMain)
import Test.Framework.TH
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2

import Tests.TemplParser

{-# ANN module "HLint: ignore Use camelCase" #-}

prop_reverse :: [Int] -> Bool
prop_reverse xs = reverse (reverse xs) == xs

main :: IO ()
main = defaultMain [ $(testGroupGenerator)
                   , Tests.TemplParser.testGroup
                   ]
