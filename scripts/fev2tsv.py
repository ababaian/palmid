#!/usr/bin/python2

'''
Usage:
	fev2tsv.py < input.fev > output.tsv
'''

import sys

FieldNames = [
	"score",
	"query",
	"gene",
	"order",
	"confidence",
	"qlen",
	"pp_start",
	"pp_end",
	"pp_length",
	"v1_length",
	"v2_length",
	"pssm_total_score",
	"motifs",
	"super"]

s = ""
for Name in FieldNames:
	if len(s) > 0:
		s += "\t"
	s += Name
print(s)

for Line in sys.stdin:
	Dict = {}
	Fields = Line.strip().split('\t')
	for Field in Fields:
		n = Field.find('=')
		if n < 0:
			continue
		Name = Field[:n]
		Value = Field[n+1:]
		Dict[Name] = Value
	s = ""
	for Name in FieldNames:
		try:
			Value = Dict[Name]
		except:
			Value = "."
		if len(s) > 0:
			s += "\t"
		s += Value
	print(s)
