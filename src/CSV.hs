module CSV where

import Data.List (length)
import Data.List.Split (splitOn)
import Data.Map (Map (..))
import qualified Data.Map as Map

newtype CSV
  = CSV [Line]
  deriving (Eq, Show)

type Line = Map String String

newtype Header
  = Header [String]
  deriving (Eq, Show)

(<$$>) :: (Functor f0, Functor f1) => (a -> b) -> f0 (f1 a) -> f0 (f1 b)
(<$$>) = fmap . fmap

parse :: String -> Maybe CSV
parse = CSV <$$> (parseBody . parseHeader . lines)

parseHeader :: [String] -> Maybe (Header, [String])
parseHeader (header : body) = Just (Header fields, body)
 where
  fields = splitOn "," header
parseHeader _ = Nothing

parseBody :: Maybe (Header, [String]) -> Maybe [Line]
parseBody (Just (header, body)) = mapM (parseLine header) body
parseBody Nothing = Nothing

parseLine :: Header -> String -> Maybe Line
parseLine (Header header) line =
  if length header == length values
    then
      let pairs = header `zip` values
       in Just $ foldr (uncurry Map.insert) Map.empty pairs
    else Nothing
 where
  values = splitOn "," line