module Security
  def hash_password hash
    hash <<= 'pixelsandonions'
    for i in 0..23
      hash = Digest::SHA1.hexdigest hash
    end
    hash
  end
end