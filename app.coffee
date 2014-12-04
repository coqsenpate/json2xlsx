fs = require('fs')
Iconv = require('iconv-lite')
fastCsv = require 'fast-csv'
filedata = fs.readFileSync 'pyrexdata.json', {encoding: 'utf8'}

Iconv.extendNodeEncodings()

filedata = JSON.parse filedata

SEPARATOR =";"
DELIMITER = '"'

escapeValue = (value)->
	if typeof value is 'string'
		value = value.replace DELIMITER, "#{DELIMITER}#{DELIMITER}", "g"
	value
	

for table, rows of filedata
	console.log "table:", table
	columns = []
	csvString = ""

	csvHeaders = ""

	for row in rows
		csvString += "\n"
		for column in columns
			if row[column]?
				value = escapeValue row[column]
				csvString += "\"#{value}\""
				delete row[column]
			csvString += SEPARATOR

		for field, value of row
			alreadyListed = false
			for column in columns
				if field is column
					alreadyListed = true
			if alreadyListed is false
				console.log "column:", field
				columns.push field
				value = escapeValue value
				csvString += "\"#{value}\""
				csvString += SEPARATOR


	for column in columns
		csvHeaders += "\"#{column}\"; "

	csvString = csvHeaders + csvString

	fs.writeFileSync "#{table}.csv", csvString, {encoding: "ISO-8859-1"}
