<h1 class="title">trimr: Response Time Trimming in R</h1>
<h4 class="author"><em>James A. Grange</em></h4>
<h4 class="date"><em>2015-07-31</em></h4>
</div>


<div id="overview" class="section level2">
<h2>Overview</h2>
<p><em>trimr</em> is an R package that implements most commonly-used response time trimming methods, allowing the user to go from a raw data file to a finalised data file ready for inferential statistical analysis.</p>
<p>The trimming functions fall broadly into three families (together with the function names for each method implemented in <em>trimr</em>):</p>
<ol style="list-style-type: decimal">
<li><strong>Absolute Value Criterion:</strong>
<ul>
<li>absoluteRT</li>
</ul></li>
<li><strong>Standard Deviation Criterion:</strong>
<ul>
<li>sdTrim</li>
</ul></li>
<li><strong>Recursive / Moving Criterion:</strong>
<ul>
<li>nonRecursive</li>
<li>modifiedRecursive</li>
<li>hybridRecursive</li>
</ul></li>
</ol>
</div>
<div id="example-data" class="section level2">
<h2>Example Data</h2>
<p><em>trimr</em> ships with some example data—“exampleData”—that the user can explore the trimming functions with. This data is simulated (i.e., not real), and has some subjects’ data missing (e.g., subject 31 was removed before data analsysis). This data is from a task switching experiment, where RT and accuracy was recorded for two experimental conditions: Switch, when the task switched from the previous trial, and Repeat, when the task repeated from the previous trial.</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># load the trimr package</span>
<span class="kw">library</span>(trimr)

<span class="co"># activate the data</span>
<span class="kw">data</span>(exampleData)

<span class="co"># look at the top of the data</span>
<span class="kw">head</span>(exampleData)</code></pre>
<pre><code>##   participant condition   rt accuracy
## 1           1    Switch 1660        1
## 2           1    Switch  913        1
## 3           1    Repeat 2312        1
## 4           1    Repeat  754        1
## 5           1    Switch 3394        1
## 6           1    Repeat  930        1</code></pre>
<p>The exampleData consists of 4 columns:</p>
<ul>
<li><strong>participant:</strong> Codes the number of each participant in the experiment</li>
<li><strong>condition:</strong> In this example, there are two experimental conditions: “Switch”, and “Repeat”.</li>
<li><strong>rt:</strong> Logs the response time of the participant in milliseconds.<br /></li>
<li><strong>accuracy:</strong> Logs the accuracy of the response. 1 codes a correct response, 0 an error response.</li>
</ul>
<p>At a minimum, users using their own data need columns with these names in their data frame they are using <em>trimr</em> for. The user can use RTs logged in milliseconds (as here) or in seconds (e.g., 0.657). The user can control the number of decimal places to round the trimmed data to.</p>
<hr />
</div>
<div id="absolute-value-criterion" class="section level2">
<h2>Absolute Value Criterion</h2>
<p>The absolute value criterion is the simplest of all of the trimming methods available (except of course for having no trimming). An upper- and lower-criterion is set, and any response time that falls outside of these limits are removed. The function that performs this trimming method in <em>trimr</em> is called <em>absoluteRT</em>.</p>
<div id="absolutert" class="section level3">
<h3>absoluteRT</h3>
<p>In this function, the user decalares lower- and upper-criterion for RT trimming (minRT and maxRT arguments, respectively); RTs outside of these criteria are removed. Note that these criteria must be in the same unit as the RTs are logged in within the data frame being used. The function also has some other important arguments:</p>
<ul>
<li><strong>omitErrors:</strong> If the user wishes error trials to be removed from the trimming, this needs to be set to TRUE (it is set to this by default). Alternatively, some users may wish to keep error trials included. Therefore, set this argument to FALSE.</li>
<li><strong>returnType:</strong> Here, the user can control how the data are returned. “raw” returns trial-level data after the trials with trimmed RTs are removed; “mean” returns calculated mean RT per participant per condition after trimming; “median” returns calculated median RT per participant per condition after trimming. This is set to “mean” by default.</li>
<li><strong>digits:</strong> How many digits to round the data to after trimming? If the user has a data frame where the RTs are recorded in seconds (e.g., 0.657), this argument can be left at its default value of 3. However, if the data are logged in milliseconds, it might be best to change this argument to zero, so there are no decimal places in the rounding of RTs (e.g., 657).</li>
</ul>
<p>In this first example, let’s trim the data using criteria of RTs less than 150 milliseconds and greater than 2,000 milliseconds, with error trials removed before trimming commences. Let’s also return the mean RTs for each condition, and round the data to zero decimal places.</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># perform the trimming</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">absoluteRT</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">maxRT =</span> <span class="dv">2000</span>, 
                          <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># look at the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1    901    742
## 2           2   1064    999
## 3           3   1007    802
## 4           4   1000    818
## 5           5   1131    916
## 6           6   1259   1067</code></pre>
<p>Note that <em>trimr</em> returns a data frame with each row representing each participant in the data file (logged in the participant column), and separate columns for each experimental condition in the data.</p>
<p>If the user wishes to recive back trial-level data, change the “returnType” argument to “raw”:</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># perform the trimming</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">absoluteRT</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">maxRT =</span> <span class="dv">2000</span>, 
                          <span class="dt">returnType =</span> <span class="st">&quot;raw&quot;</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># look at the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##    participant condition   rt accuracy
## 1            1    Switch 1660        1
## 2            1    Switch  913        1
## 4            1    Repeat  754        1
## 6            1    Repeat  930        1
## 7            1    Switch 1092        1
## 11           1    Repeat  708        1</code></pre>
<p>Now, the data frame returned is in the same shape as the initial data file, but rows containing trimmed RTs are removed.</p>
<hr />
</div>
</div>
<div id="standard-deviation-criterion" class="section level2">
<h2>Standard Deviation Criterion</h2>
<p>This trimming method uses a standard deviation multiplier as the upper criterion for RT removal (users still need to enter a lower-bound manually). For example, this method can be used to trim all RTs 2.5 standard deviations above the mean RT. This trimming can be done per condition (e.g., 2.5 SDs above the mean of each condition), per participant (e.g., 2.5 SDs above the mean of each participant), or per condition per participant (e.g., 2.5 SDs above the mean of each participant for each condition).</p>
<div id="sdtrim" class="section level3">
<h3>sdTrim</h3>
<p>In this function, the user delcares a lower-bound on RT trimming (e.g., 150 milliseconds) and an upper-bound in standard deviations. The value of standard deviation used is set by the SD argument. How this is used varies depending on the values the user passes to two important function arguments:</p>
<ul>
<li><strong>perCondition:</strong> If set to TRUE, the trimming will occur above the mean of each experimental condition in the data file.</li>
<li><strong>perParticipant:</strong> If set to TRUE, the trimming will occur above the mean of each participant in the data file.</li>
</ul>
<p>Note that if both are set to TRUE, the trimming will occur per participant per condition (e.g., if SD is set to 2.5, the function will trim RTs 2.5 SDs above the mean RT of each participant for each condition).</p>
<p>In this example, let’s trim RTs faster than 150 milliseconds, and greater than 3 SDs above the mean of each participant, and return the mean RTs:</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># trim the data</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">sdTrim</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">sd =</span> <span class="dv">3</span>, 
                      <span class="dt">perCondition =</span> <span class="ot">FALSE</span>, <span class="dt">perParticipant =</span> <span class="ot">TRUE</span>, 
                      <span class="dt">returnType =</span> <span class="st">&quot;mean&quot;</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># look at the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1   1042    775
## 2           2   1136   1052
## 3           3   1020    802
## 4           4   1094    834
## 5           5   1169    919
## 6           6   1435   1156</code></pre>
<p>Now, let’s trim per condition per participant:</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># trim the data</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">sdTrim</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">sd =</span> <span class="dv">3</span>, 
                      <span class="dt">perCondition =</span> <span class="ot">TRUE</span>, <span class="dt">perParticipant =</span> <span class="ot">TRUE</span>, 
                      <span class="dt">returnType =</span> <span class="st">&quot;mean&quot;</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># look at the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1   1099    742
## 2           2   1136   1038
## 3           3   1028    802
## 4           4   1103    834
## 5           5   1184    916
## 6           6   1461   1136</code></pre>
<hr />
</div>
</div>
<div id="recursive-moving-criterion" class="section level2">
<h2>Recursive / Moving Criterion</h2>
<p>Three functions in this family implement the trimming methods proposed &amp; discussed by van Selst &amp; Jolicoeur (1994): <strong>nonRecursive</strong>, <strong>modifiedRecursive</strong>, and <strong>hybridRecursive</strong>. van Selst &amp; Jolicoeur noted that the outcome of many trimming methods is influenced by the sample size (i.e., the number of trials) being considered, thus potentially producing bias. For example, even if RTs are drawn from identical positively-skewed distributions, a “per condition per participant” SD procedure (see sdTrim above) would result in a higher mean estimate for small sample sizes than larger sample sizes. This bias was shown to be removed when a “moving criterion” (MC) was used; this is where the SD used for trimming is adapted to the sample size being considered.</p>
<div id="nonrecursive" class="section level3">
<h3>nonRecursive</h3>
<p>The non-recursive method proposed by van Selst &amp; Jolicoeur (1994) is very similar to the standard deviation method outlined above with the exception that the user does not specify the SD to use as the upper bound. The SD used for the upper bound is rather decided by the sample size of the RTs being passed to the trimming function, with larger SDs being used for larger sample sizes. Also, the function only trims per participant per condition.</p>
<p>The <strong>nonRecursive</strong> function checks the sample size of the data being passed to it, and looks up the SD criterion required for the data’s sample size. The function looks in a data file contained in <em>trimr</em> called <strong>linearInterpolation</strong>. Should the user wish to see this data file (although the user will never need to access it if they are not interested), type:</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># load the data</span>
<span class="kw">data</span>(linearInterpolation)

<span class="co"># show the first 20 rows (there are 100 in total)</span>
linearInterpolation[<span class="dv">1</span>:<span class="dv">20</span>, ]</code></pre>
<pre><code>##    sampleSize nonRecursive modifiedRecursive
## 1           1        1.458             8.000
## 2           2        1.680             6.200
## 3           3        1.841             5.300
## 4           4        1.961             4.800
## 5           5        2.050             4.475
## 6           6        2.120             4.250
## 7           7        2.173             4.110
## 8           8        2.220             4.000
## 9           9        2.246             3.920
## 10         10        2.274             3.850
## 11         11        2.310             3.800
## 12         12        2.326             3.750
## 13         13        2.334             3.736
## 14         14        2.342             3.723
## 15         15        2.350             3.709
## 16         16        2.359             3.700
## 17         17        2.367             3.681
## 18         18        2.375             3.668
## 19         19        2.383             3.654
## 20         20        2.391             3.640</code></pre>
<p>Notice there are two columns. This current function will only look in the nonRecursive column; the other column is used by the modifiedRecursive function, discussed below. If the sample size of the current set of data is 16 RTs (for example), the function will use an upper SD criterion of 2.359, and will proceed much like the sdTrim function’s operations.</p>
<p>Note the user can only be returned the mean trimmed RTs (i.e., there is no “returnType” argument for this function).</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># trim the data</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">nonRecursive</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># see the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1   1053    732
## 2           2   1131   1026
## 3           3   1017    799
## 4           4   1089    818
## 5           5   1169    908
## 6           6   1435   1123</code></pre>
</div>
<div id="modifiedrecursive" class="section level3">
<h3>modifiedRecursive</h3>
<p>The modifiedRecursive function is more involved than the nonRecursive function. This function performs trimming in cycles. It first temporarily removes the slowest RT from the distribution; then, the mean of the sample is calculated, and the cut-off value is calculated using a certain number of SDs around the mean, with the value for SD being determined by the current sample size. In this procedure, required SD <em>decreases</em> with increased sample size (cf., the nonRecursive method, with <em>increasing</em> SDs with increasing sample size; see the linearInterpolation data file above); see Van Selst and Jolicoeur (1994) for justification.</p>
<p>The temporarily removed RT is then returned to the sample, and the fastest and slowest RTs are then compared to the cut-off, and removed if they fall outside. This process is then repeated until no outliers remain, or until the sample size drops below four. The SD used for the cut-off is thus <em>dynamically altered</em> based on the sample size of each cycle of the procedure, rather than static like the nonRecursive method.</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># trim the data</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">modifiedRecursive</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># see the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1    792    691
## 2           2   1036    927
## 3           3    958    716
## 4           4   1000    712
## 5           5   1107    827
## 6           6   1309   1049</code></pre>
</div>
<div id="hybridrecursive" class="section level3">
<h3>hybridRecursive</h3>
<p>van Selst and Jolicoeur (1994) reported slight opposing trends of the non-recursive and modified-recursive trimming methods (see page 648, footnote 2). They therefore, in passing, suggested a “hybrid-recursive” method might balance the opposing trends. The hybrid-recursive method simply takes the average of the non-recursive and the modified-recursive methods.</p>
<pre class="sourceCode r"><code class="sourceCode r"><span class="co"># trim the data</span>
trimmedData &lt;-<span class="st"> </span><span class="kw">hybridRecursive</span>(<span class="dt">data =</span> exampleData, <span class="dt">minRT =</span> <span class="dv">150</span>, <span class="dt">digits =</span> <span class="dv">0</span>)

<span class="co"># see the top of the data</span>
<span class="kw">head</span>(trimmedData)</code></pre>
<pre><code>##   participant Switch Repeat
## 1           1    923    711
## 2           2   1083    976
## 3           3    987    757
## 4           4   1044    765
## 5           5   1138    867
## 6           6   1372   1086</code></pre>
<hr />
</div>
</div>
<div id="references" class="section level2">
<h2>References</h2>
<p>Van Selst, M. &amp; Jolicoeur, P. (1994). A solution to the effect of sample size on outlier elimination. <em>Quarterly Journal of Experimental Psychology, 47 (A)</em>, 631–650.</p>
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
