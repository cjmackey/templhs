module Dom.Templ(module Dom.TemplTypes, update) where

import Dom.TemplFunctions
import Dom.TemplTypes
--import Haste.DOM
import Haste (eval)

jsesc [] = []
jsesc (c:xs) = case c of
  '\\' -> "\\\\" ++ jsesc xs
  '"' -> "\\\"" ++ jsesc xs
  '\n' -> "\\n" ++ jsesc xs
  _ -> c : jsesc xs

update :: Templ a -> a -> String -> IO ()
update t a i = do
  --  e <- elemByID i
  let s = toStr t a i
  let si = jsesc i
  let ss = jsesc s
  -- eval $ "document.getElementById('someid').innerHTML = 'asdf'"
  {-let es = "document.getElementById(\"" ++ si ++ "\").innerHTML = \"" ++ ss ++ "\""
  eval $ "console.log(\"" ++ jsesc "asdf" ++ "\")"
  eval $ "console.log(\"" ++ si ++ "\")"
  eval $ "console.log(\"" ++ ss ++ "\")"
  eval $ "console.log(document.getElementById(\"" ++ si ++ "\").innerHTML)"
  eval $ "console.log(\"" ++ jsesc es ++ "\")"
  eval $ "document.getElementById(\"" ++ si ++ "\").innerHTML = \"blah\"" 
  -}
  eval $ "document.getElementById(\"" ++ si ++ "\").innerHTML = \"" ++ ss ++ "\"" 
  return ()

