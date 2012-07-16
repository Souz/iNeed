class AutocompleteController < ApplicationController

#@author: Amir Emad

#@author: Amir Emad
#@summary: Responsible for returning the autucomplete results in json format.
#@paramname: "needs" => List of needs staring with a ceratin parameter
#@paramname: "list" => The param needs but sorted according to number of needers
  def needs_categories
    if params[:term].lstrip != ''
      params[:term] = params[:term].lstrip
    end
    if params[:term]
    	x = params[:term]
      results = Need.where(:name => /^#{x}/i,:deleted => 'false').limit(10)
      results = results + Need.all.to_a.keep_if{|n| n.has_start(x.downcase) and !n.deleted and !results.include?(n)}
      results = results.sort { |a,b| b.total_needers <=> a.total_needers }
    else
     results = []
    end

    results = results + Category.leaves.to_a.keep_if{|c| c.name.downcase.start_with?(params[:term].downcase) | c.has_start(params[:term].downcase)}[0,10]
    results = results.map {|n| Hash[id: n.id, label: n.name, name: n.name,type: n.class.name]}
    render json: results          
  end

  def needs
    if params[:term][0] == ' '
      for i in 0..params[:term].length-1
        if params[:term][i]!= ' '
          params[:term] = params[:term][i,params[:term].length]
          break
        end
      end
    end
    if params[:term]
      x = params[:term]
     needs = Need.where(:name => /^#{x}/i,:deleted => 'false')
    else
     needs = []
    end
    needs = needs.sort { |a,b| b.total_needers <=> a.total_needers }
    list = needs.map {|n| Hash[id: n.id, label: n.name, name: n.name,type: n.class.name]}
    render json: list            
  end
end
