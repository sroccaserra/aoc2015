import Data.Char
import Text.ParserCombinators.ReadP


partOne = id

data Expr = AssignInt Int String
          | Assign String String
          | AndInt Int String String
          | And String String String
          | Or String String String
          | LShift String Int String
          | RShift String Int String
          | Not String String
          deriving (Show)

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

main = interact $ unlines . map show . partOne . parse
