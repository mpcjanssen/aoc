#include <tcl.h>
#include <stdlib.h>

#define __unused __attribute__((unused))


Tcl_Obj *pointObj(int x, int y) {
    Tcl_Obj *objv[2];
    objv[0] = Tcl_NewIntObj(x);
    objv[1] = Tcl_NewIntObj(y);
    return Tcl_NewListObj(2, objv);
}

int L2p_Cmd(__unused ClientData cdata, Tcl_Interp *interp, int objc, Tcl_Obj *const objv[]) {
    int length;
    Tcl_Obj **items;
    Tcl_Obj *result1;
    Tcl_Obj *result2;
    Tcl_Obj *points1;
    Tcl_Obj *intersection;
    int x;
    int y;
    Tcl_Obj *filled = Tcl_NewBooleanObj(1);


    if (objc != 3) {
        Tcl_WrongNumArgs(interp, 1, objv, "desc1 desc2");
        return TCL_ERROR;
    }
    if (Tcl_ListObjGetElements(interp, objv[1], &length, &items) != TCL_OK) {
        return TCL_ERROR;
    }

    points1 = Tcl_NewDictObj();
    result1 = Tcl_NewListObj(length, NULL);
    x = 0;
    y = 0;
    if (Tcl_ListObjAppendElement(interp, result1, pointObj(x, y)) != TCL_OK) {
        return TCL_ERROR;
    }
    for (int idx = 0; idx < length; idx++) {
        char *desc = Tcl_GetString(items[idx]);
        char dir = desc[0];
        int dx = 0;
        int dy = 0;
        int steps = strtol(desc + 1,NULL,10);
        switch (dir) {
            case 'U':
                dy = -1;
                break;
            case 'D':
                dy = 1;
                break;
            case 'L':
                dx = -1;
                break;
            case 'R':
                dx = 1;
                break;
            default:
                Tcl_SetObjResult(interp, Tcl_NewStringObj("Invalid direction.", -1));
                return TCL_ERROR;
        }
        while (steps > 0) {
            x += dx;
            y += dy;
            Tcl_Obj *point = pointObj(x, y);
            if (Tcl_ListObjAppendElement(interp, result1, point) != TCL_OK) {
                return TCL_ERROR;
            }
            Tcl_DictObjPut(interp, points1, point, filled);
            steps--;
        }
    }

    if (Tcl_ListObjGetElements(interp, objv[2], &length, &items) != TCL_OK) {
        return TCL_ERROR;
    }
    intersection = Tcl_NewListObj(0, NULL);
    Tcl_ListObjAppendElement(interp, intersection, pointObj(0,0));
    result2 = Tcl_NewListObj(length, NULL);
    x = 0;
    y = 0;
    if (Tcl_ListObjAppendElement(interp, result2, pointObj(x, y)) != TCL_OK) {
        return TCL_ERROR;
    }
    for (int idx = 0; idx < length; idx++) {
        char *desc = Tcl_GetString(items[idx]);
        char dir = desc[0];
        int dx = 0;
        int dy = 0;
        int steps = strtol(desc + 1,NULL,10);
        switch (dir) {
            case 'U':
                dy = -1;
                break;
            case 'D':
                dy = 1;
                break;
            case 'L':
                dx = -1;
                break;
            case 'R':
                dx = 1;
                break;
            default:
                Tcl_SetObjResult(interp, Tcl_NewStringObj("Invalid direction.", -1));
                return TCL_ERROR;
        }
        while (steps > 0) {
            Tcl_Obj *found;
            x += dx;
            y += dy;
            Tcl_Obj *point = pointObj(x, y);
            if (Tcl_ListObjAppendElement(interp, result2, point) != TCL_OK) {
                return TCL_ERROR;
            }
            Tcl_DictObjGet(interp, points1, point, &found);
            if (found != NULL) {
                Tcl_ListObjAppendElement(interp, intersection, point);
            }
            steps--;
        }

    }
    Tcl_Obj *result = Tcl_NewListObj(0, NULL);
    Tcl_ListObjAppendElement(interp, result, result1);
    Tcl_ListObjAppendElement(interp, result, result2);
    Tcl_ListObjAppendElement(interp, result, intersection);

    Tcl_SetObjResult(interp, result);
    return TCL_OK;
}

DLLEXPORT __unused  int L2p_Init(Tcl_Interp *interp) {
    Tcl_InitStubs(interp, "8.5", 0);
    Tcl_CreateObjCommand(interp, "l2p", L2p_Cmd, NULL, NULL);
    return TCL_OK;
}
