
module App

  # Note: initializers are not functional yet
  #
  # Unlike helpers/hooks/state, initializers cannot be added onto a window
  # object at runtime, which makes integration with this wrapper difficult.
  #
  def self.with_initializers(app)
    app.config do
      # add_initializer(:foo) do
      # end
    end
  end
end
