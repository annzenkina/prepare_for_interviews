def groupAnagrams(strs)
  anagram_hash = Hash.new()
  strs.each do |str|
    sorted_str = str.chars.sort.join
    if !anagram_hash.key?(sorted_str)
      anagram_hash[sorted_str] = []
    end

    anagram_hash[sorted_str] << str
  end

  p anagram_hash.values
  anagram_hash.values
end

strs = ["act","pots","tops","cat","stop","hat"]
groupAnagrams(strs)