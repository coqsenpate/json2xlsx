fs = require('fs')
xlsx = require 'node-xlsx'

FILE_NAME = "pyrexdata"


filedata = fs.readFileSync 'pyrexdata.json', {encoding: 'utf8'}
filedata = JSON.parse filedata

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

fs.writeFileSync "#{FILE_NAME}.xlsx", buffer
