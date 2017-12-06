module ControlFlow 
    ( while
    , whileCounter
    ) where

while :: (a -> Bool) -> (a -> IO a) -> a -> IO a
while predicate action value = do
    newValue <- action value
    if predicate newValue then 
        while predicate action newValue
    else return newValue


whileCounter :: Int -> (String -> IO String) -> String -> IO String
whileCounter counter action value
    | counter > 0 = do
        newValue <- action value
        whileCounter (counter - 1) action newValue
    | otherwise = return $ take 1 value