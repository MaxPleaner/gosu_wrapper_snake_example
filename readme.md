This is a demo snake game using my 
[gosu_wrapper](http://github.com/maxpleaner/gosu_wrapper).

Although the wrapper lib is available as a gem, in this project it's present
in the source code because I was building this concurrently. 

Everything custom here is in [`app.rb`](./app.rb), [`app/helpers.rb`](./app/helpers.rb),
[`app/hooks.rb`](./app/hooks.rb), or [`app/state.rb`](app/state.rb).

There are methods here for creating a grid and drawing it that can potentially
be re-used elsewhere.

The snake game isn't wonderful, fancy, or even fully functional - it's just
a quick demo built to learn/practice gosu.
