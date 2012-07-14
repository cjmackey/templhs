module Dom.TemplFunctions where


import Dom.TemplTypes

toStr :: Templ a -> a -> String -> String
toStr (RawTempl s) _ _ = s
toStr (EvalTempl n f _) a i = nodeStr n i $ f a
toStr (CompositeTempl l) a i = concat $ map (\(e,j) -> toStr e a (i ++ "_" ++ show j)) $ zip l ([0..] :: [Int])

nodeStr :: TemplNode -> String -> String -> String
nodeStr (TemplNode n _) i body = "<" ++ n ++ " id=\"" ++ i ++ "\">" ++ body ++ "</" ++ n ++ ">"

