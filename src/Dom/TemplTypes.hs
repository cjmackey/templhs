module Dom.TemplTypes where


type NodeID = String
type TagName = String


data TemplNode = TemplNode TagName (Maybe NodeID)

data Templ a = CompositeTempl [Templ a]
             | RawTempl String
             | EvalTempl TemplNode (a -> String) (Maybe String)




