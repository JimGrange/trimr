<div id="header">
<h1 class="title">trimr: Response Time Trimming in R</h1>
<h4 class="author"><em>James A. Grange</em></h4>
<h4 class="date"><em>2014-12-26</em></h4>
</div>


<p>This package provides (hopefully) useful functions for performing all standard methods of response time (RT) trimming used in experimental psychology. These include:</p>
<ul>
<li><code>absoluteRT</code>: Absolute trimming using an RT value as the cut-off (e.g., trimming all RTs below 150ms and above 2,000ms).</li>
<li><code>absoluteSD</code>: Absolute trimming using standard deviation as the cut-off (e.g., trimming all RTs slower than 2SDs above the group mean).</li>
<li><code>perCell</code>: Uses SD trimming per cell of the experimental design (e.g., trimming all RTs 2.5SD above the mean of each experimental condition).</li>
<li><code>perParticipant</code>: Uses SD trimming per participant (e.g., trimming all RTs 2.5SD above each participant’s mean).</li>
<li><code>perCellParticipant</code>: Uses SD trimming per cell, per participant. This is the more typical trimming method used (e.g., trimming all RTs 2.5SD above each participant’s mean per cell of the experimental design).</li>
<li><code>nonRecursive</code>: Removes any RT that falls outside a certain number of SDs from the mean (of the whole sample of RTs) being considered, with the value of SD being determined by the sample size of the distribution, with a lower SD value being used for smaller sample sizes.</li>
<li><code>modifiedRecursive</code>: An iterative trimming procedure.</li>
<li><code>hybridRecursive</code>: Takes the average of the modifiedRecursive and the nonRecursive functions.</li>
</ul>
<div id="the-data" class="section level1">
<h1>The Data</h1>
<p>The package ships with some example data to explore the above functions with; to load this, use</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># load the trimr package</span>
<span class="kw">library</span>(trimr)

<span class="co"># load the data set</span>
<span class="kw">data</span>(exampleData)

<span class="co"># examine it</span>
<span class="kw">head</span>(exampleData)</code></pre>
<pre><code>##   participant condition   rt accuracy
## 1           1    Switch 1660        1
## 2           1    Switch  913        1
## 3           1    Repeat 2312        1
## 4           1    Repeat  754        1
## 5           1    Switch 3394        1
## 6           1    Repeat  930        1</code></pre>
<p>This is a data frame containing data from 32 participants (identification coded in the “participant” column) in two different experimental conditions (the “condition” column). Their response time (“rt”) in milliseconds and “accuracy” is coded (1 is a correct response, 0 an error response).</p>
<p>Of course, this data is here just for example usage. You would usually be using your own data. Ensure that your data set has columns with the same names above (even if you have other columns, or they are in a different order).</p>
</div>
<div id="the-functions" class="section level1">
<h1>The Functions</h1>
<div id="absolutert" class="section level2">
<h2>absoluteRT</h2>
</div>
<div id="absolutesd" class="section level2">
<h2>absoluteSD (to do)</h2>
</div>
<div id="percell-to-do" class="section level2">
<h2>perCell (to do)</h2>
</div>
<div id="perparticipant-to-do" class="section level2">
<h2>perParticipant (to do)</h2>
</div>
<div id="percellparticipant-to-do" class="section level2">
<h2>perCellParticipant (to do)</h2>
</div>
<div id="nonrecursive-to-do" class="section level2">
<h2>nonRecursive (to do)</h2>
</div>
<div id="modifiedrecursive-to-do" class="section level2">
<h2>modifiedRecursive (to do)</h2>
</div>
<div id="hybridrecursive-to-do" class="section level2">
<h2>hybridRecursive (to do)</h2>
</div>
<div id="section" class="section level2">
<h2></h2>
</div>
</div>



<!-- dynamically load mathjax for compatibility with self-contained -->
<script>
  (function () {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src  = "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
    document.getElementsByTagName("head")[0].appendChild(script);
  })();
</script>

</body>
</html>
