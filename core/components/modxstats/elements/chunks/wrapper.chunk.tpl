<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MODX Community Statistics</title>

    <link href="[[+assets_url]]css/stats.css" rel="stylesheet">
    <link href="[[+assets_url]]rickshaw/rickshaw.min.css" rel="stylesheet">
</head>
<body>

<header>
    <h1>MODX Community Statistics <span style="color:#777;font-size:70%;">as of June 7th, 2014</span> </h1>
    <p>Every hour a script is fired to collect some key metrics from the MODX forums. These are stored and shown to you, right here. Help improve this page! <a href="https://github.com/Mark-H/modxStats">Fork the repo on GitHub</a>, pull requests are very welcome.</p>
    <p>Some welcome improvements include..</p>
    <ul>
        <li>Connection with Github to keep track of the number of open and closed issues and pull requests</li>
        <li>Better design (well, *any* design really)</li>
        <li>Perhaps a way to download data; it is currently shown at the bottom in a simple table, but that will become unwieldy as more data is collected.</li>
    </ul>
</header>

<div class="block-wrapper">
    <div class="block block-recent-posts">
        <div class="inner">
            <h2>Number of Recent Posts</h2>
            <p class="description">The Recent Posts forum page shows all posts that happened in the last 42 days. By keeping track of this metric you can get a good idea of the long term continued activity and how this fluctuates over time. </p>
            <div class="graph-container" id="graph-recent-posts">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
    <div class="block block-number-members">
        <div class="inner">
            <h2>Number of Members</h2>
            <p class="description">The absolute number of registered users on the MODX forums. </p>
            <div class="graph-container" id="graph-total-members">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
    <div class="block block-number-posts">
        <div class="inner">
            <h2>Number of Posts</h2>
            <p class="description">The absolute number of posts. </p>
            <div class="graph-container" id="graph-total-posts">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
    <div class="block block-number-threads">
        <div class="inner">
            <h2>Number of Threads</h2>
            <p class="description">The absolute number of threads on the forum. </p>
            <div class="graph-container" id="graph-total-threads">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
    <div class="block block-number-github-open">
        <div class="inner">
            <h2>Open Issues & Pull Requests</h2>
            <p class="description">Find out what issues and pull requests are waiting to be addressed.</p>
            <div class="graph-container" id="graph-total-github-open">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
    <div class="block block-number-github-closed">
        <div class="inner">
            <h2>Closed Issues & Pull Requests</h2>
            <p class="description">Shows you recent activity in terms of closing issues and pull requests.</p>
            <div class="graph-container" id="graph-total-github-closed">
                <div class="y_axis"></div>
                <div class="chart"></div>
            </div>
        </div>
    </div>
</div>

<div class="block-wrapper">
    <div class="block block-raw-forum-stats">
        <h3>Raw Forum Stats</h3>
        <table>
            <thead>
            <tr>
                <td>Date</td>
                <td>Posts in last 42 days</td>
                <td>Post Count</td>
                <td>Thread Count</td>
                <td>Member Count</td>
            </tr>
            </thead>
            <tbody>
                [[+forum_stats]]
            </tbody>
        </table>
    </div>
    <div class="block block-raw-github-stats">
        <h3>Raw GitHub Stats</h3>
        <table>
            <thead>
            <tr>
                <td>Date</td>
                <td>Open Issues</td>
                <td>Open Pull Requests</td>
                <td>Closed Issues</td>
                <td>Closed Pull Requests</td>
            </tr>
            </thead>
            <tbody>
                [[+github_stats]]
            </tbody>
        </table>
    </div>
</div>

<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="[[+assets_url]]/rickshaw/vendor/d3.min.js"></script>
<script src="[[+assets_url]]/rickshaw/vendor/d3.layout.min.js"></script>
<script src="[[+assets_url]]/rickshaw/rickshaw.min.js"></script>

<script>
$(document).on('ready', function() {
    // Fix block heights so they appear nicely side by side
    function newGraph (holder, dataUrl, series) {
        return new Rickshaw.Graph.Ajax({
            element: holder.find('.chart').get(0),
            min: 'auto',
            width: holder.width() - 50, // 50px padding from the y-axis
            height: 250,
            dataURL: dataUrl,
            onData: function (d) {
                //d[0].data = data;
                return d
            },
            onComplete: function (transport) {
                var graph = transport.graph;
                var detail = new Rickshaw.Graph.HoverDetail({
                    graph: graph,
                    yFormatter: function(y) {
                        return formatNumber(y);
                    }
                });

                var x_axis = new Rickshaw.Graph.Axis.Time({ graph: graph });
                x_axis.render();

                var y_axis = new Rickshaw.Graph.Axis.Y({
                    graph: graph,
                    orientation: 'left',
                    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
                    element: holder.find('.y_axis').get(0)
                });
                y_axis.render();
            },
            series: series
        });
    };

    newGraph($('#graph-recent-posts'), '[[+assets_url]]connector.php?action=web/stats/forum/recent', [
        {
            name: 'Recent Posts',
            color: '#c05020'
        }
    ]);
    newGraph($('#graph-total-members'), '[[+assets_url]]connector.php?action=web/stats/forum/members', [
        {
            name: 'Total # of Members',
            color: '#c05020'
        }
    ]);
    newGraph($('#graph-total-posts'), '[[+assets_url]]connector.php?action=web/stats/forum/posts', [
        {
            name: 'Posts',
            color: '#c05020'
        }
    ]);
    newGraph($('#graph-total-threads'), '[[+assets_url]]connector.php?action=web/stats/forum/threads', [
        {
            name: 'Threads',
            color: '#c05020'
        }
    ]);
    newGraph($('#graph-total-github-open'), '[[+assets_url]]connector.php?action=web/stats/github/open', [
        {
            name: 'Open Pull Requests',
            color: '#0c0502'
        },{
            name: 'Open Issues',
            color: '#c05020'
        },
    ]);
    newGraph($('#graph-total-github-closed'), '[[+assets_url]]connector.php?action=web/stats/github/closed', [
        {
            name: 'Closed Pull Requests',
            color: '#0c0502'
        },{
            name: 'Closed Issues',
            color: '#c05020'
        },
    ]);

    function formatNumber(num) {
        var parts = num.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    };
});
</script>

</body>
</html>
