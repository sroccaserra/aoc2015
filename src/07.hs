import Data.Bits
import Data.Char
import Data.List
import Data.Maybe
import Data.Word
import Data.Map (Map, (!))
import qualified Data.Set as Set
import Data.Tree
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP
import Debug.Trace

partOne xs = wired ! "a"
  where (_, sorted) = until (\(t, _) -> Map.null t) untangle (treeFromExprs xs, [])
        wired = foldl eval Map.empty $ reverse sorted

data Expr = AssignInt Word16 String
          | Assign String String
          | AndInt Word16 String String
          | And String String String
          | Or String String String
          | LShift String Word16 String
          | RShift String Word16 String
          | Not String String
          deriving (Show, Ord, Eq)

untangle :: (Map Expr [Expr], [Expr]) -> (Map Expr [Expr], [Expr])
untangle (m, out) | Map.null m = (Map.empty, out)
untangle (tree, out) = (tree'', leaf:out)
  where leaf = Set.findMin $ Map.keysSet $ Map.filter null tree
        tree' = Map.delete leaf tree
        tree'' = Map.map (delete leaf) tree'

eval :: Map String Word16 -> Expr -> Map String Word16
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
eval m (LShift src n dst) = Map.insert dst (shiftL value $ fromIntegral n) m
  where value = m!src
eval m (RShift src n dst) = Map.insert dst (shiftR value $ fromIntegral n) m
  where value = m!src
eval m (Not src dst) = Map.insert dst (complement value) m
  where value = m!src

dst :: Expr -> String
dst (AssignInt _ dst) = dst
dst (Assign _ dst) = dst
dst (AndInt _ _ dst) = dst
dst (And _ _ dst) = dst
dst (Or _ _ dst) = dst
dst (LShift _ _ dst) = dst
dst (RShift _ _ dst) = dst
dst (Not _ dst) = dst

expressionsByName xs = foldl (\m x -> Map.insert (dst x) x m) Map.empty xs

treeFromExprs xs = (foldl (\a e -> Map.insert e (deps m e) a)) Map.empty xs
  where m = expressionsByName xs

deps :: Map String Expr -> Expr -> [Expr]
deps m e = map (m !) $ depNames e

depNames :: Expr -> [String]
depNames (AssignInt _ _) = []
depNames (Assign src _) = [src]
depNames (AndInt _ src dst) = [src]
depNames (And s1 s2 _) = [s1, s2]
depNames (Or s1 s2 _) = [s1, s2]
depNames (LShift src _ _) = [src]
depNames (RShift src _ _) = [src]
depNames (Not src _) = [src]

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

value :: ReadP Word16
value = read <$> munch1 isDigit
symbol = munch1 isAlpha

---
-- Running

main = interact $ show . partOne . parse
