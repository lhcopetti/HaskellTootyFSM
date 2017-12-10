module Main where

import Lib
import TootyFSM
import ControlFlow (while)
import System.IO (hSetBuffering, stdout, BufferMode(..))


main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStrLn "The beginning!"
    while (/= endFSM) runTootyFSM startFSM
    putStrLn "The end!"