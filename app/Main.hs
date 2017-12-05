module Main where

import Lib
import TootyFSM


main :: IO ()
main = do
    putStrLn "The beginning!"
    while (/= endFSM) runTootyFSM startFSM
    putStrLn "The end!"

while :: (a -> Bool) -> (a -> IO a) -> a -> IO a
while predicate action value = do
    newValue <- action value
    if predicate newValue then 
        while predicate action newValue
    else return newValue