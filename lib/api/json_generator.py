import json

with open('charts.json', 'w') as json_file:
    charts = {
        "charts":
        {
            "edges": []
        }
    }

    def chartNodeTemplate(j, n):
        node = {"node": {"chartID": "{}".format(n),
                         "datapoints": [
                             "{}".format(n)
        ],
            "agentID": "{}".format(j),
            "chartName": "Datapoint {}".format(n)
        }

        }
        return node
    c = 1
    for _ in range(1, 4):
        for n in range(1, 10):
            charts["charts"]["edges"].append(chartNodeTemplate(_, c))
            c += 1
    json.dump(charts, json_file, indent=4, sort_keys=True)
