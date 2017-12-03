module Console 
    ( prompt
    ) where

prompt :: String -> IO Bool
prompt xs = do
    putStrLn $ xs ++ " (Y/n)?"
    valueRead <- getChar
    return $ valueRead == 'Y'