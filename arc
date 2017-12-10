#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MaxVertexNum 20 //顶点数设置为100
#define INFINITY 100000
#define maxSize 100
#define ERROR -1
#define MAXK 1e3
clock_t start,stop;
double duration;
typedef enum{false = 0,true = 1}PointTag;
int visited[MaxVertexNum];
/*---------------------------------结构体-----------------------------------------*/
/*十字链表的结构体*/
//结点结构
struct ArcNode{
    int tailvex,headvex;//弧的头和顶点的位置
    struct ArcNode *hlink,*tlink;//头尾指针
    weightType weight;
};
typedef struct ArcNode *Arcbox;

//头结点
struct XNode{
    dataType data;
    Arcbox firstIn,firstOut;
};
typedef struct XNode xlist[MaxVertexNum];

/*十字链表-图的定义*/
struct OLGNode{
    int nv;
    int ne;
    xlist G;//邻接表
};
typedef struct OLGNode *OLGraph;
/*---------------------------------结构体-----------------------------------------*/


/*---------------------------------下面是创建十字链表函数-----------------------------------------*/
//建立十字链表的图
OLGraph biuldGraph_arc(){
    OLGraph Graph;
    Edge E;
    int nv,i;

    FILE*fp;
     if((fp=fopen("E://数据结构//图 实验//matric1.txt","r"))==NULL)
    {
        printf("fail to open!");
        exit(0);
    }
    fscanf(fp,"%d\n",&nv);//顶点个数
    Graph=CreateGraph_arc(nv);//初始化有nv个顶点但没有边的图

    fscanf(fp,"%d\n",&Graph->ne);//读入边数
    if(Graph->ne!=0){
        E=(Edge)malloc(sizeof(struct ENode));
        //A=(Arcbox)malloc(sizeof(struct ArcNode));//为结点申请空间
        for(i=0;i<Graph->ne;i++){
            fscanf(fp,"%d %d %d\n",&E->v1,&E->v2,&E->weight);//读入边的信息
            //fscanf(fp,"%d %d %d\n",&A->tailvex,&A->headvex,&A->weight);//读入边的信息
            InsertEdge_arc(Graph,E);//把这条边插入矩阵信息中
        }
    }
    //读入顶点的数据
    for(i=0;i<Graph->nv;i++){
        fscanf(fp,"%c",&Graph->G[i].data);//读入A、B、C顶点的数据
    }
    return Graph;

}

//初始化有nv个顶点但没有边的图
OLGraph CreateGraph_arc(int nvNum){
    Vertex v;
    OLGraph Graph;
    //为这个图申请空间
    Graph =(OLGraph)malloc(sizeof(struct OLGNode));
    Graph->nv=nvNum;
    Graph->ne=0;
    /*
    for(v=0;v<Graph->nv;v++)
        Graph->G[v].firstIn=NULL;
        Graph->G[v].firstOut=NULL;出错原因！！

    */
    for(v=0;v<Graph->nv;v++){
        Graph->G[v].firstIn=NULL;
        Graph->G[v].firstOut=NULL;
    }
    return Graph;
}

//把这条边插入邻接表信息中
void InsertEdge_arc(OLGraph Graph,Edge E){
    Arcbox A;
    A=(Arcbox)malloc(sizeof(struct ArcNode));//为结点申请空间

    A->weight=E->weight;
    A->headvex=E->v2;
    A->tailvex=E->v1;

    A->tlink=Graph->G[A->tailvex].firstOut;//出去的指针解决了
    Graph->G[A->tailvex].firstOut=A;//把出去的边连接上
    //解决firstIn,hlink的指针
    A->hlink=Graph->G[A->headvex].firstIn;
    Graph->G[A->headvex].firstIn=A;
}

/*---------------------------------创建十字链表函数结束-----------------------------------------*/
