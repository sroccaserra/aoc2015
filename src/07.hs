import Data.Bits
import Data.Char
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP


partOne = foldl eval Map.empty

data Expr = AssignInt Int String
          | Assign String String
          | AndInt Int String String
          | And String String String
          | Or String String String
          | LShift String Int String
          | RShift String Int String
          | Not String String
          deriving (Show)

eval :: Map String Int -> Expr -> Map String Int
eval m (AssignInt n dst) = Map.insert dst n m
eval m (Assign src dst) = Map.insert dst value m
  where value = m!src
eval m (AndInt n src dst) = Map.insert dst (n .&. value) m
  where value = m!src
eval m (And s1 s2 dst) = Map.insert dst (v1 .&. v2) m
  where v1 = m!s1
        v2 = m!s2
eval m (Or s1 s2 dst) = Map.insert dst (v1 .|. v2) m
  where v1 = m!s1
        v2 = m!s2
eval m (LShift src n dst) = Map.insert dst ((2^16-1) .&. (shiftL value n)) m
  where value = m!src
eval m (RShift src n dst) = Map.insert dst (shiftR value n) m
  where value = m!src
eval m (Not src dst) = Map.insert dst ((2^16-1) .&. (complement value)) m
  where value = m!src

---
-- Parsing

parse = map parseLine . lines

parseLine = fst . last . readP_to_S parser

parser :: ReadP Expr
parser = choice [assignIntP, assignP, andIntP, andP, orP, lShiftP, rShiftP, notP]

assignIntP = AssignInt <$> value <* string " -> " <*> symbol
assignP = Assign <$> symbol <* string " -> " <*> symbol
andIntP = AndInt <$> value <* string " AND " <*> symbol <* string " -> " <*> symbol
andP = And <$> symbol <* string " AND " <*> symbol <* string " -> " <*> symbol
orP = Or <$> symbol <* string " OR " <*> symbol <* string " -> " <*> symbol
lShiftP = LShift <$> symbol <* string " LSHIFT " <*> value <* string " -> " <*> symbol
rShiftP = RShift <$> symbol <* string " RSHIFT " <*> value <* string " -> " <*> symbol
notP = Not <$ string "NOT " <*> symbol <* string " -> " <*> symbol

value :: ReadP Int
value = read <$> munch1 isDigit
symbol = munch1 isAlpha

---
-- Running

main = interact $ show . partOne . parse
