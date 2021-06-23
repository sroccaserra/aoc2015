#!/usr/bin/env bash

re='children: 3|cats: 7|samoyeds: 2|pomeranians: 3|akitas: 0|vizslas: 0|goldfish: 5|trees: 3|cars: 2|perfumes: 1\b'
rg "$re" src/16.txt
