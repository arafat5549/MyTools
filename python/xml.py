#!/usr/bin/python
# -*- coding:utf-8 -*- 

#小工具删除指定XML的Tag
from bs4 import BeautifulSoup

tagname_id = ['snippet','description','tessellate']

infile = 'doc.kml'
outfile = "out.xml"

with open(infile) as reader:
    xml = reader.read()

deleted_id = []

# with open('delete.txt') as reader:
#     for line in reader:
#         line = line.strip()
#         deleted_id.append(line)

def has_delete_id(tag):
    return tag.name in tagname_id # and tag.id.string in deleted_id

soup = BeautifulSoup(xml, 'html.parser')

tags = soup(has_delete_id)

for tag in tags:
    tag.decompose()

f = open(outfile , "w") 
f.write(soup.prettify())
f.close()

#print(soup.prettify())