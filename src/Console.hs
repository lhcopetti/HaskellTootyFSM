module Console 
    ( prompt
    ) where

prompt :: String -> IO Bool
prompt xs = do
    putStrLn $ xs ++ " (Y/n)?"
    valueRead <- getLine
    return $ valueRead == "Y"