for stranger in TempUser.all
  # delete all the ratings
  for rating in stranger.ratings
    rating.destroy
  end
  
  stranger.destroy
end