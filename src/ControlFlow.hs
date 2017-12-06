module ControlFlow 
    ( while
    ) where

while :: (a -> Bool) -> (a -> IO a) -> a -> IO a
while predicate action value = do
    newValue <- action value
    if predicate newValue then 
        while predicate action newValue
    else return newValue