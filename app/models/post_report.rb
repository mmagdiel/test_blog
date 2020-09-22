class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    contentClean = post.content.split.map { |word| word.gsub(/\W/,'') }
    PostReport.new(
      contentClean.count,
      contentClean.map(&:downcase).group_by{ |word| word }.transform_values(&:size)
    )
  end
end