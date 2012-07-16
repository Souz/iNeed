module ComplaintsHelper

	def Get_Complaint_Sender(m)
	#method to return that takes as an argument a message object, 
	#returning the supplier ID that issued this message.(Integer)
		return m.Supplier_ID
	end

	def Get_Complaint_Date(m)
	#method to return that takes as an argument a message object, returning it's date. (Date)	
		return m.date
	end

	def Get_Complaint_Content(m)
	#method to return that takes as an argument a message object 
	#returning it's content (String).	
		return m.content
	end

	def set_Read(m)
	#method to return that takes as an argument a message object 
	#returning nothing, changing the status of the message to READ (read = true)
		m.update_attributes(read: "true")
	end
	def set_Unread(m)
	#method to return that takes as an argument a message object 
	#returning nothing, changing the status of the message to Unread (read = false)
		m.update_attributes(read: "false")
	end

	def delete (m)
	#method that takes as an argument a message object, deleting it. (redirection is necessary after using that)
		m.destroy
	end
end
