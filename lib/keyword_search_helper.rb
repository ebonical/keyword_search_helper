module KeywordSearchHelper
  QUOTE_REGEX = /(\A|\s*)"(.*?)"(\s*|\z)/
  ACTION_REGEX = /^([\w\d\-]+)\:(.*)/
  INDEX_REGEX = /^\$(\d+)$/
  
  def extract(input_string, options = {})
    [:only, :exclude].each do |key|
      instance_variable_set("@#{key}_actions", [options[key]].flatten.compact.map(&:to_sym))
    end
    
    if !(@only_actions.blank? || @exclude_actions.blank?)
      raise ArgumentError, ":only and :exclude options cannot both be set"
    end
    
    output = {:keywords => []}
    
    # Extract double-quoted phrases - first protecting any part of the string 
    # that may look like an index marker.
    quoted = []
    string = input_string.to_s.gsub('$','$$').gsub(QUOTE_REGEX) { quoted << $2; " $#{quoted.size - 1} " }
    # break everything left into single words
    tokens = string.split(' ')
    tokens.each_with_index do |token, idx|
      # check for an action
      is_action = false
      
      if token =~ ACTION_REGEX
        action = $1.to_sym
        keyword = $2
        is_action = @only_actions.blank? && !@exclude_actions.include?(action) || 
                    @only_actions.include?(action)
      end
      
      if is_action
        output[action] ||= []
        
        if keyword.blank?
          # If the keyword is blank then it should be a quoted phrase.
          # Get the index value from the next value in the tokens array and
          # insert the value from the 'quoted' array
          if tokens[idx + 1] && (match = tokens[idx + 1].match(INDEX_REGEX))
            i = match[1].to_i
            output[action] << quoted[i]
            quoted[i] = ''
          end
        else
          output[action] << keyword
        end
      elsif token =~ INDEX_REGEX
        # If an indexing token then pull value from 'quoted' array
        output[:keywords] << quoted[$1.to_i]
      else
        output[:keywords] << token
      end
    end
    
    # compact and remove empty arrays
    output.each { |key, array| array.reject!(&:blank?); output.delete(key) if array.blank? }
    # restore $ characters to as inputted
    output.each { |key, array| array.map! { |value| value.gsub('$$','$') } }
    
    output
  end
  
  extend self
end
