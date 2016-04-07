# LLLFoldableTableView
[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/raozhizhen/JMRoundedCorner/master/LICENSE)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_7)&nbsp;

遇到这样一个需求、效果如下图

![](https://github.com/CruiseLiugit/LiuFoldableTableView/blob/master/030-accompany-1310.png?raw=true)

![](https://github.com/CruiseLiugit/LiuFoldableTableView/blob/master/030-accompany-1320.png?raw=true)


服务器返回的数据结构如下

```json
{
    "data": [
             {
             "game_id": "12",
             "game_name": "游戏名称",
             "game_icon": "http://weidu.file.dev.putaocloud.com/file/89978156a5cb8bba695c2026109dc0d30f41fa7e_120x120.jpg",
             "description_icon": "http://weidu.file.dev.putaocloud.com/file/89978156a5cb8bba695c2026109dc0d30f41fa7e_120x120.jpg",
             "description_title": "游戏理念",
             "description": "[游戏名称]将经典的七巧板和iPad有机结合，通过AR科技实现实体+虚拟的互动，儿童线下完成七巧板拼图，和线上精灵伙伴淘淘进行冒险之旅，解决一个又一个难题。古典的七巧板智慧完美融入先进的科技之中，实现科技陪伴儿童成长。不仅带给儿童丰富有趣的游戏体验，更大的价值是将深刻的教育理念\"Grit\"(由美籍亚裔心理学家、宾夕法尼亚大学副教授Angela Lee Duck worth 与2005年提出)潜移默化的在儿童的心灵里和行为中，培养儿童坚毅、勇敢的优秀品格，以及有效提升儿童的空间想象力、发散型思维逻辑能力和动手创造能力!",
             "levels": [
                        {
                        "title": "森林主题关卡",
                        "icon": "http://weidu.file.dev.putaocloud.com/file/89978156a5cb8bba695c2026109dc0d30f41fa7e_120x120.jpg",
                        "levels_list": [
                                        {
                                        "level_id": "1",
                                        "title": "森林里的小山坡"
                                        },
                                        {
                                        "level_id": "2",
                                        "title": "挡路的石头"
                                        },
                                        {
                                        "level_id": "3",
                                        "title": "毛毛虫的蜕变"
                                        }
                                        ]
                        },
                        {
                        "title": "湖泊主题关卡",
                        "icon": "http://weidu.file.dev.putaocloud.com/file/89978156a5cb8bba695c2026109dc0d30f41fa7e_120x120.jpg",
                        "levels_list": [
                                        {
                                        "level_id": "1",
                                        "title": "湖泊里的小山坡"
                                        },
                                        {
                                        "level_id": "2",
                                        "title": "湖泊的石头"
                                        },
                                        {
                                        "level_id": "3",
                                        "title": "湖泊的蜕变"
                                        },
                                        {
                                        "level_id": "4",
                                        "title": "湖泊里面游泳"
                                        }
                                        ]
                        },
                        {
                        "title": "沙漠主题关卡",
                        "icon": "http://weidu.file.dev.putaocloud.com/file/89978156a5cb8bba695c2026109dc0d30f41fa7e_120x120.jpg",
                        "levels_list": [
                                        {
                                        "level_id": "1",
                                        "title": "湖泊里的小山坡"
                                        },
                                        {
                                        "level_id": "2",
                                        "title": "湖泊的石头"
                                        },
                                        {
                                        "level_id": "3",
                                        "title": "湖泊的蜕变"
                                        },
                                        {
                                        "level_id": "4",
                                        "title": "湖泊里面游泳"
                                        },
                                        {
                                        "level_id": "4",
                                        "title": "湖泊里面游泳"
                                        }
                                        ]
                        }
                        ]
             }
             ],
    "msg": "",
    "http_code": 200
}
```

### 最终效果

![](https://github.com/CruiseLiugit/LiuFoldableTableView/blob/master/00.png?raw=true)

![](https://github.com/CruiseLiugit/LiuFoldableTableView/blob/master/01.png?raw=true)

![](https://github.com/CruiseLiugit/LiuFoldableTableView/blob/master/02.png?raw=true)


### 更新日志
- 2016/4/7  1.0.0版本 : 完成折叠效果

