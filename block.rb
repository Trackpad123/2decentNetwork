require 'digest'

class Block
  attr_reader :index, :time, :data, :nonce
  
  def initialize index:, time:, data:, previous:
    @index = index
    @time = time
    @data = data
    @nonce = nil
    @previous = previous
  end
  
  def hash
    Digest::SHA256.hexdigest "#{index}#{time}#{data}#{previous_hash}"
  end
  
  def verification
    Digest::SHA256.hexdigest "#{hash}#{nonce}"
  end
  
  def mine!
    @nonce = find_nonce
    self
  end
  
  def valid?
    valid_proof? nonce
  end
  
  def previous_hash
    @previous.nil? ? 'genesis' : @previous.hash
  end
  
  private
  
  def find_nonce
    _nonce = 0
    _nonce += 1 until valid_proof? _nonce
    _nonce
  end
  
  def valid_proof? _nonce
    Digest::SHA256.hexdigest("#{hash}#{_nonce}")[0..3] == "0000"
  end
end