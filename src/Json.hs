module Json where

import CSV (CSV (..), Line)

import Data.List (intercalate)
import qualified Data.Map as Map

fromCSV :: CSV -> String
fromCSV (CSV lines) = "[\n" ++ items ++ "\n]"
 where
  items = intercalate ",\n" (map fromItem lines)

fromItem :: Line -> String
fromItem line = "  {\n" ++ fields ++ "\n  }"
 where
  fields = intercalate ",\n" . map (uncurry keyValueToField) . Map.toList $ line

keyValueToField :: String -> String -> String
keyValueToField k v = "    \"" ++ k ++ "\": " ++ "\"" ++ v ++ "\""