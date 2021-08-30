#!/usr/bin/python2

'''
Usage:
	fev2tsv.py < input.fev > output.tsv
'''

import sys

FieldNames = [
	"score",
	"query",
	"class",
	"comments",
	"dist1",
	"dist2",
	"frame",
	"group",
	"motifs",
	"order",
	"palm_end",
	"palm_length",
	"palm_start",
	"pssm_min_score",
	"pssm_total_score",
	"qlen",
	"super",
	"xlat" ]

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
