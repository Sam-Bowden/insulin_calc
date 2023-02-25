import qualified Data.Map.Strict as Map
import System.IO
import Text.Read
import Text.Printf

type Carbs = Float
type Name = String
type Weight = Float
type Multiplicity = Float
type Item = (Name, Weight, Multiplicity)
type Dose = Float
type Database = Map.Map Name Carbs
type InsulinCarbRatio = Int
type InsulinCarbRatios = Map.Map Name InsulinCarbRatio
type Meal = [Item]
data Result a b = Ok a | Err b

sumCarbs :: Meal -> Database -> Result Carbs [Name]
sumCarbs [] db = Ok 0
sumCarbs ((name, weight, mult):items) db = case (Map.lookup name db, sumCarbs items db) of
  (Just per_100g, Ok sum) -> Ok ((weight * (per_100g / 100) * mult) + sum) 
  (Just _,  Err names) -> Err names
  (Nothing, Ok _) -> Err [name]
  (Nothing, Err names) -> Err (name:names)

calcDose :: Carbs -> InsulinCarbRatio -> Dose
calcDose sum carb_ratio = sum / fromIntegral carb_ratio

getItems :: IO [Item]
getItems = do
  putStr "> "
  hFlush stdout
  e <- getLine
  case words e of
    [n, w, m] -> case (readMaybe w, readMaybe m) of
      (Just w, Just m) -> do
        xs <- getItems
        return ((n, w, m):xs)
      _ -> do
        putStrLn "Invalid format: weight and multiplicity must be valid numbers!"
        getItems
    [":d"] -> return ([])
    _ -> do
      putStrLn "Invalid format: there must be three space separated arguments!"
      getItems
     
main :: IO ()
main = do
  putStr "Insulin to carbs ratio: "
  hFlush stdout
  input <- getLine
  case Map.lookup input insulin_carb_ratios of
    Just insulin_carb_ratio -> do
      putStrLn "Enter items (<name> <weight> <multiplicity>). Type :d to finish:"
      meal <- getItems
      case sumCarbs meal db of
        Ok sum -> do
          printf "Total carbs: %.2fg\n" sum
          printf "Calculated insulin dose: %.2f units\n" (calcDose sum insulin_carb_ratio)
        Err items -> putStrLn $ "Items not found in database: " ++ show items
    Nothing -> putStrLn $ "Insulin to carbs ratio with name '" ++ input ++ "' has not been set"

-- Database and carb ratios temporarily in code while prototyping
db :: Database
db = Map.fromList [("Apple", 10), ("Banana", 20.9), ("Orange", 10)]
insulin_carb_ratios :: InsulinCarbRatios
insulin_carb_ratios = Map.fromList [("Breakfast", 7), ("Dinner", 11), ("Tea", 10)]