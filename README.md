Keyword Search Helper
=====================

Extracts keywords and special query actions from a search string. 
This does not presume to know how you will use your keywords once they've been extracted.


Example
=======

    # Simple query
    input = "little furry fox"
    KeywordSearchHelper.extract(input) # => {:keywords => ['little','furry','fox']}
    
    # Quoted phrases
    input = 'little "furry fox"'
    KeywordSearchHelper.extract(input) # => {:keywords => ['little','furry fox']}
    
    # With some special triggers
    input = "tag:banana since:2010-10-10 fox"
    KeywordSearchHelper.extract(input) # => {:tag => ['banana'], :since => ['2010-10-10'], :keywords => ['fox']}
    
    # For actions with spaces just wrap in double quotes
    input = 'tag:"spaced tag"'

Copyright (c) 2010 Ebony Charlton, released under the MIT license