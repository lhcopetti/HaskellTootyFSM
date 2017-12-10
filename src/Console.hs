module Console  where

import Control.Concurrent (threadDelay)
import ControlFlow (whileCounter)

prompt :: String -> IO Bool
prompt xs = do
    putStrLn $ xs ++ " (Y/n)?"
    valueRead <- getLine
    return $ valueRead == "Y"


getCharAction :: Char -> IO Char
getCharAction x = getChar

printLoadingAction :: String -> IO String
printLoadingAction x = do
    putStr $ "\r" ++ [head x]
    threadDelay 500000
    return $ drop 1 x

printLoadingAction' :: String -> String -> IO String
printLoadingAction' prompt x = do
    putStr ("\r" ++ message)
    threadDelay 500000
    return (drop 1 x)
        where
            message = prompt ++ "... " ++ [head x]

delayWithPrompt :: String -> Int -> IO ()
delayWithPrompt msg count = do 
    whileCounter count (printLoadingAction' msg) (cycle "\\|/-")
    return ()