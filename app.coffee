fs = require('fs')
xlsx = require 'node-xlsx'

if process.argv[2]?
	inputPath = process.argv[2]
	if process.argv[3]?
		outputPath = process.argv[3]
	else
		outputPath = inputPath.replace /\.json$/i, ".xlsx"
else
	throw "Error: No input file specified."

filedata = require "./#{inputPath}"

sheets = []

for table, rows of filedata
	console.log "table:", table
	columns = []
	outputTable = []
	
	for row in rows
		outputRow = []

		for column in columns
			if row[column]?
				outputRow.push row[column]
			else
				outputRow.push null

		for field, value of row
			alreadyListed = false
			for column in columns
				if field is column
					alreadyListed = true
			if alreadyListed is false
				columns.push field
				outputRow.push value

		outputTable.push outputRow


	outputTable.unshift columns

	sheets.push
		name: table
		data: outputTable

buffer = xlsx.build sheets

fs.writeFileSync outputPath, buffer
console.log "Written file:", outputPath
