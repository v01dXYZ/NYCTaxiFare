{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine

csv :: Diagram B 
csv = (text "CSV" # fc white # fontSize 15 <> circle 0.8 # fc green) # named "csv"

r :: Diagram B
r = (text "R" # fc white # fontSize 20 <> circle 0.8 # fc red) # named "r"

boxLabel x =  strutY 0.5 === text x # fontSize 15 # pad 5
postgres :: Diagram B
postgres =  ( text "Postgres" # fontSize 20 <> rect 4.5 2 # fc lavender ) # named "postgres" 
clickhouse :: Diagram B
clickhouse =  ( text "Clickhouse" # fontSize 20 <> rect 5.5 2 # fc pink )  # named "clickhouse"

dia = (csv === boxLabel "Données" === boxLabel "brutes") |||
      strutX 2 |||
     (postgres === boxLabel "Traitement" ) |||
      strutX 2 ||| 
     (clickhouse === boxLabel "Aggrégation") |||
      strutX 2 |||
      ( r === boxLabel "Analyse" )

as = (with & shaftStyle %~ lw thick)

example :: Diagram B
example = dia # connectOutside' as  "csv" "postgres" # connectOutside' as "postgres" "clickhouse" # connectOutside' as "clickhouse" "r" # centerXY # pad 1.2

f :: Int -> Diagram B
f 0 = example

main = mainWith f
