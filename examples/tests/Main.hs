module Main where

import Control.Concurrent(threadDelay)
import Control.Monad.IO.Class(liftIO)
import Data.Text(pack, unpack)
import System.Directory(canonicalizePath, getCurrentDirectory)
import Test.WebDriver
import Test.WebDriver.Classes()
import Test.WebDriver.Commands
import Test.WebDriver.Commands.Wait


exampleUrl x = do
  d0 <- liftIO getCurrentDirectory
  d1 <- liftIO $ canonicalizePath (d0 ++ "/../" ++ x ++ "/index.html")
  return ("file://" ++ d1)

openExample :: String -> WD ()
openExample x = do
  u <- exampleUrl x
  openPage u
  return ()

main :: IO ()
main = do
  s <- runWD defaultSession $ createSession defaultCaps
  runWD s $ finallyClose $ do
    openExample "asdf"
    
    e <- findElem (ById $ pack "someid")
    t <- getText e
    let s = unpack t
    liftIO $ print s
    expect $ s == "asdf rootvarwargle"
  return ()


