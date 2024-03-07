PalTypes = {"Anubis","Baphomet","Baphomet_Dark","Bastet","Bastet_Ice","Boar","Carbunclo","ColorfulBird","Deer","DrillGame","Eagle", "ElecPanda",
                "Ganesha","Garm","Gorilla","Hedgehog","Hedgehog_Ice","Kirin","Kitsunebi","LittleBriarRose","Mutant","Penguin","RaijinDaughter",
                "SharkKid","SheepBall","Umihebi","Werewolf","WindChimes","Suzaku","Suzaku_Water","FireKirin","FairyDragon","FairyDragon_Water","SweetsSheep",
                "WhiteTiger","Alpaca","Serpent","Serpent_Ground","DarkCrow","BlueDragon","PinkCat","NegativeKoala","FengyunDeeper","VolcanicMonster",
                "VolcanicMonster_Ice","GhostBeast","RobinHood","LazyDragon","LazyDragon_Electric","AmaterasuWolf","LizardMan","Blueplatypus",
                "BirdDragon","BirdDragon_Ice","ChickenPal","FlowerDinosaur","FlowerDinosaur_Electric",
                "ElecCat","IceHorse","IceHorse_Dark","GrassMammoth","CatVampire","SakuraSaurus","SakuraSaurus_Water","Horus","KingBahamut",
                "BerryGoat","IceDeer","BlackGriffon","WhiteMoth","CuteFox","FoxMage","PinkLizard",
                "WizardOwl","Kelpie","NegativeOctopus","CowPal","Yeti","Yeti_Grass","VioletFairy","HawkBird","FlowerRabbit",
                "LilyQueen","LilyQueen_Dark","QueenBee","SoldierBee","CatBat","GrassPanda","GrassPanda_Electric","FlameBuffalo","ThunderDog",
                "CuteMole","BlackMetalDragon","GrassRabbitMan","IceFox","JetDragon","DreamDemon","Monkey","Manticore","Manticore_Dark",
                "KingAlpaca","PlantSlime","MopBaby","MopKing","CatMage","PinkRabbit","ThunderBird","HerculesBeetle","SaintCentaur",
                "NightFox","CaptainPenguin","WeaselDragon","SkyDragon","HadesBird","RedArmorBird","Ronin","FlyingManta","BlackCentaur",
                "FlowerDoll","NaughtyCat","CuteButterfly","DarkScorpion","ThunderDragonMan","WoolFox",
                "LazyCatfish","Deer_Ground","FireKirin_Dark",
                "KingAlpaca_Ice","RobinHood_Ground","GrassMammoth_Ice","Kelpie_Fire","SharkKid_Fire","LizardMan_Fire","LavaGirl","FlameBambi",
                "Umihebi_Fire","WindChimes_Ice"}

PalTypesTakenOut = {"Owl","PinkKangaroo","BeardedDragon","WaterLizard","GuardianDog","GrassDragon","BlackFurDragon","SifuDog","TentacleTurtle","ElecLion","GoldenHorse","BadCatgirl","DarkMutant","BrownRabbit",
                       "FeatherOstrich","WingGolem","ScorpionMan","BlueberryFairy"}


Moves = {10,11,12,14,22,33,34,35,36,37,38,39,40,42,43,48,50,51,53,54,55,57,58,59,60,61,62,63,65,66,67,68,69,70,71,72,73,74,75,78,79,81,83,84,85,86,87,90,91,92,93,94,95,97,98,99,100,106,110,112,113}

component = nil
util = nil
index = 0

RegisterHook("/Script/Pal.PalMonsterCharacter:MasterWazaUpdateWhenLevelUp", function(self)
    if component == nil then
        component = FindAllOf("PalOtomoHolderComponentBase")[1]
    end

    if util == nil then
        util = StaticFindObject("/Script/Pal.Default__PalUtility")
    end

    local slot = -1

    local params = self:get():GetCharacterParameterComponent():GetIndividualParameter().SaveParameter
    local temp = self:get():GetCharacterParameterComponent():GetIndividualParameter().SaveParameter.EquipWaza

    local charID = params.CharacterID
    local level = params.Level
    local attack = params.Rank_Attack
    local defence = params.Rank_Defence
    local craft = params.Rank_CraftSpeed
    local exp = params.Exp

    local num_Otomo = component:GetMaxOtomoNum()

    for i=1,num_Otomo do
        local flag = true

        if component:GetOtomoIndividualCharacterSlot((index + i - 1) % num_Otomo):IsEmpty() then
            flag = false
        end

        if flag then
            local compare = component:GetOtomoIndividualHandle((index + i - 1) % num_Otomo):TryGetIndividualParameter().SaveParameter
            if charID ~= compare.CharacterID then
                flag = false
            elseif level ~= compare.Level then
                flag = false
            elseif attack ~= compare.Rank_Attack then
                flag = false
            elseif defence ~= compare.Rank_Defence then
                flag = false
            elseif craft ~= compare.Rank_CraftSpeed then
                flag = false
            elseif exp ~= compare.Exp then
                flag = false
            end

            for j=1,#temp do
                if flag and temp[j] ~= compare.EquipWaza[j] then
                    flag = false
                end

                if not flag then
                    break
                end
            end

            if flag then
                slot = (index + i - 1) % num_Otomo
                index = (index + i) % num_Otomo
                break
            end
        end
    end

-- Mounts are randomized:
    if slot ~= -1 then
        if component:GetSpawnedOtomoID() == slot and component:IsRidingBySpawnSlotID() then
            util:GetOffFromPal(PlayerController:GetRidingCharacter(), true, false)
        end

        params.CharacterID = FName(PalTypes[math.random(#PalTypes)])

        for i=1,#temp do
            temp[i] = Moves[math.random(#Moves)]
        end
        component:OnUpdateSlot(component:GetOtomoIndividualCharacterSlot(slot), component:GetOtomoIndividualHandle(slot))
    end

-- Mounts are not randomized:
--     if slot ~= -1 then
--         local PlayerController = FindAllOf("PalPlayerController")[1]
--         if not (component:GetSpawnedOtomoID() == slot and component:IsRidingBySpawnSlotID()) then
--             params.CharacterID = FName(PalTypes[math.random(#PalTypes)])
--
--             for i=1,#temp do
--                 temp[i] = Moves[math.random(#Moves)]
--             end
--             component:OnUpdateSlot(component:GetOtomoIndividualCharacterSlot(slot), component:GetOtomoIndividualHandle(slot))
--         end
--     end
end)


print("---------------------------------RandomPals loaded successfully---------------------------------")