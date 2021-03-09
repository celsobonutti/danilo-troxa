module Main where

import qualified CSV
import qualified Json
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [filename] ->
      readFile filename >>= printCsv
    _ ->
      putStrLn "Incorrect number of arguments"

printCsv :: String -> IO ()
printCsv csv = case CSV.parse csv of
  Nothing ->
    putStrLn "Error parsing CSV"
  Just parsedCSV ->
    putStrLn $ Json.fromCSV parsedCSV