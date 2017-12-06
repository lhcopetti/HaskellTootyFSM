module Main where

import Lib
import TootyFSM
import ControlFlow (while)


main :: IO ()
main = do
    putStrLn "The beginning!"
    while (/= endFSM) runTootyFSM startFSM
    putStrLn "The end!"