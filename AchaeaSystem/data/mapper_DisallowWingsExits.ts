
import * as _ from "lodash";
import { RoomCheckRule } from "../classes/Rule";
import mapModel from "../helpers/MapModel";

const rooms = _.filter(mapModel.rooms, (room) =>
    _.some(room.mSpecialExits, (_, exitCommand) => exitCommand.match("duana"))
);

export const disallowWingsExits = new RoomCheckRule(rooms, 'rooms with wings exits');