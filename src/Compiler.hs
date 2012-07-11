{-# LANGUAGE DeriveDataTypeable #-}
module Main where

import System.Console.CmdArgs

import Dom.TemplCompiler

data TemplHSCompiler = TemplHSCompiler {file :: FilePath}
          deriving (Show, Data, Typeable)

--margs = 
--mode = cmdArgsMode margs

main :: IO ()
main = do 
  a <- cmdArgs TemplHSCompiler { file = def &= args &= typ "FILE" }
  case file a of
    "" -> print "Need a filename! Try --help"
    f -> readFile f >>= (\contents -> case compile contents of
                            Left _ -> putStrLn "Failure while compiling!"
                            Right output -> writeFile (f ++ ".hs") output)
